import { RocBridgeDelegate, LifeCycleManager } from "./manager/life-cycle-manager";
import { BaseManager } from "./manager/base/base-manager";

window['rocBridgeContext'] = "";

type InterfaceCallback = (response: any) => void;

type InterfaceImplementation = (parameter: Map<string, any>, callback: InterfaceCallback) => any | void;

class ManagerGroup {
    lifeCycleManager: LifeCycleManager;
};

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
    managerGroup: ManagerGroup;

    constructor() {
        this.managerGroup = new ManagerGroup();
        
        this.managerGroup.lifeCycleManager = new LifeCycleManager();
        this.managers.push(this.managerGroup.lifeCycleManager);
    }


}



export class RocBridge {

    static registerDelegate = (delegate: RocBridgeDelegate) => {
        RocBridgeContext.shareInstance().managerGroup.lifeCycleManager.registerDelegate(delegate);
    }

    static registerInterface = (className: string, interfaceaName: string, impl:InterfaceImplementation, sync: boolean) => {

    }

}