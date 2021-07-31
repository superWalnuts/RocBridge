import { BaseManager } from "./base/base-manager";



export abstract class RocBridgeDelegate {
    abstract main = (params: any):any => {

    }
}

export class LifeCycleManager extends BaseManager
{

    delegate: RocBridgeDelegate;

    managerInitCompleted = () => {

    }


    registerDelegate = (delegate: RocBridgeDelegate) => {
        this.delegate = delegate;
    } 


    rocBridgeInitCompleted = (params: any) => {
        if (!this.delegate) {
            throw 'You have to register a delegate，you can use registerDelegate method.'
        }
        this.delegate.main(params);
    }
}