


export abstract class RocBridgeDelegate {
    abstract main = (params: any):any => {

    }
}

export class LifeCycleManager
{

    delegate: RocBridgeDelegate;

    registerDelegate = (delegate: RocBridgeDelegate) => {
        this.delegate = delegate;
    } 
}