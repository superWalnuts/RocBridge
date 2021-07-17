import {RocBridgeDelegate, RocBridgeRegistry} from './RocBridge/context/context'

class  RocBridgeDemoDelegate extends RocBridgeDelegate
{
    main = (params: any) => {

    }    
}

var detegate = new RocBridgeDemoDelegate();
RocBridgeRegistry.registerDelegate(detegate);