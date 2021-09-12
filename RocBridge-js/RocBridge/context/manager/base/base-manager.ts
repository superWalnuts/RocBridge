import { JsNativeLinkCore } from "../link/js-native-link-core";
import { ManagerGroup } from "./manager-group";


export class BaseManager
{
    jsNativeLinkCore: JsNativeLinkCore;
    managerGroup: ManagerGroup;
    managers: BaseManager[];

    constructor(managerGroup: ManagerGroup, managers: BaseManager[], jsNativeLinkCore: JsNativeLinkCore){
        this.jsNativeLinkCore = jsNativeLinkCore;
        this.managerGroup = managerGroup;
        this.managers = managers;
        this.managers.push(this);
    }

    managerInitCompleted = () => {

    }
}