import { RocBridgeDelegate, LifeCycleManager } from "./manager/life-cycle-manager";
import { BaseManager } from "./manager/base/base-manager";
import { ManagerGroup } from "./manager/base/manager-group";
import { InterfaceImplementation } from "./manager/base/base-type";
import { JSIntefaceManager } from "./manager/js-interface-manager";

class RocBridgeContext
{
    private static instance: RocBridgeContext;
    static shareInstance = () => {
        if (!RocBridgeContext.instance) {
            RocBridgeContext.instance = new RocBridgeContext();
        }
        return RocBridgeContext.instance;
    }

    private managers: BaseManager[] = [];
    managerGroup: ManagerGroup = new ManagerGroup();

    constructor() {
        this.managerGroup.lifeCycleManager = new LifeCycleManager(this.managerGroup, this.managers);        
        this.managerGroup.jsIntefaceManager = new JSIntefaceManager(this.managerGroup, this.managers);        

        this.initAllManager();
    }

    initAllManager = () => {
        this.managers.forEach((manager)=>{
            manager.managerInitCompleted();
        });
    }
}

window['rocBridgeContext'] = RocBridgeContext.shareInstance();



export class RocBridge {

    static registerDelegate = (delegate: RocBridgeDelegate) => {
        RocBridgeContext.shareInstance().managerGroup.lifeCycleManager.registerDelegate(delegate);
    }

    static registerInterface = (className: string, interfaceaName: string, impl:InterfaceImplementation, sync: boolean) => {
        RocBridgeContext.shareInstance().managerGroup.jsIntefaceManager.registerInterface(className, interfaceaName, impl, sync);
    }

}