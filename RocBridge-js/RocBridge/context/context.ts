import { RocBridgeDelegate, LifeCycleManager } from "./manager/life-cycle-manager";
import { BaseManager } from "./manager/base/base-manager";
import { ManagerGroup } from "./manager/base/manager-group";
import { InterfaceImplementation } from "./manager/base/base-type";
import { JSIntefaceManager } from "./manager/js-interface-manager";
import { JsNativeLinkCore } from "./manager/link/js-native-link-core";

class RocBridgeContext
{
    private static instance: RocBridgeContext;
    static shareInstance = () => {
        if (!RocBridgeContext.instance) {
            RocBridgeContext.instance = new RocBridgeContext();
        }
        return RocBridgeContext.instance;
    }

    private jsNativeLinkCore: JsNativeLinkCore;
    private managers: BaseManager[] = [];
    managerGroup: ManagerGroup = new ManagerGroup();

    constructor() {
        this.jsNativeLinkCore = new JsNativeLinkCore();
        this.managerGroup.lifeCycleManager = new LifeCycleManager(this.managerGroup, this.managers, this.jsNativeLinkCore);        
        this.managerGroup.jsIntefaceManager = new JSIntefaceManager(this.managerGroup, this.managers, this.jsNativeLinkCore);        

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

    static registerInterface = (className: string, interfaceName: string, impl:InterfaceImplementation, sync: boolean) => {
        RocBridgeContext.shareInstance().managerGroup.jsIntefaceManager.registerInterface(className, interfaceName, impl, sync);
    }

}