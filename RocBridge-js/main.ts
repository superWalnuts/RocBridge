import { RocBridge } from './RocBridge/context/context'
import { RocBridgeDelegate } from './RocBridge/context/manager/life-cycle-manager';

class  RocBridgeDemoDelegate extends RocBridgeDelegate
{
    main = (params: any) => {

    }    
}

var detegate = new RocBridgeDemoDelegate();
RocBridge.registerDelegate(detegate);