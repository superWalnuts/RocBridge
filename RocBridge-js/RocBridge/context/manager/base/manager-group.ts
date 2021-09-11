import { JSIntefaceManager } from "../js-interface-manager";
import { JSNativeLinkManager } from "../js-native-link-manager";
import { LifeCycleManager } from "../life-cycle-manager";

export class ManagerGroup {
    jsNativeLinkManager: JSNativeLinkManager;
    lifeCycleManager: LifeCycleManager;
    jsIntefaceManager: JSIntefaceManager;
};