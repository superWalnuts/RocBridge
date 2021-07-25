import {RocBridgeDelegate, RocBridge} from './RocBridge/context/context'

class  RocBridgeDemoDelegate extends RocBridgeDelegate
{
    main = (params: any) => {

    }    
}

var detegate = new RocBridgeDemoDelegate();
RocBridge.registerDelegate(detegate);