import { ManagerGroup } from "./manager-group";


export class BaseManager
{
    managerGroup: ManagerGroup;
    managers: BaseManager[];

    constructor(managerGroup: ManagerGroup, managers: BaseManager[]){
        this.managerGroup = managerGroup;
        this.managers = managers;
        this.managers.push(this);
    }

    managerInitCompleted = () => {

    }
}