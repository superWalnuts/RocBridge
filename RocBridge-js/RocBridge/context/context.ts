
class RocBridgeContext
{

}

window['rocBridgeContext'] = new RocBridgeContext();

export abstract class RocBridgeDelegate {
    abstract main = (params: any) => {

    }
}

export class RocBridgeRegistry {
    static registerDelegate = (delegate: RocBridgeDelegate) => {

    }
}