import { InterfaceResponse, InterfaceResponseCode } from "./base/base-data";
import { BaseManager } from "./base/base-manager";
import { InterfaceImplementation, InterfaceInfo, InvokeInterfaceInfo } from "./base/base-type";

export class JSIntefaceManager extends BaseManager {

    className: string = 'JSIntefaceManager';
    interfaceBook: Map<string, Map<string, InterfaceInfo>> = new Map();

    registerInterface = (className: string, interfaceName: string, impl: InterfaceImplementation, isSync: boolean) => {

        if (!interfaceName || !className) {
            return false;
        }

        if (isSync === undefined) {
            isSync = false;
        }

        let classInfo = this.interfaceBook.get(className);
        if (!classInfo) {
            classInfo = new Map();
        }
        classInfo.set(interfaceName, { 'impl': impl, 'isSync': isSync });
        this.interfaceBook.set(className, classInfo);
        this.registerInterfaceToNative(className, interfaceName, isSync);
    }

    invokeInterface = (invokeInfo: InvokeInterfaceInfo, params: any) => {
        if (invokeInfo.sync) {
            this.invokeSyncInterface(invokeInfo, params);
        }else{
            this.invokeAsyncInterface(invokeInfo, params);
        }
    }

    invokeSyncInterface = (invokeInfo: InvokeInterfaceInfo, params: any) => {

        let response = new InterfaceResponse();

        let classInfo = this.interfaceBook.get(invokeInfo.className);
        let interfaceInfo: InterfaceInfo = null;

        if (classInfo) {
            interfaceInfo = classInfo.get(invokeInfo.interfaceName);
        }

        if (!interfaceInfo) {
            response.success = false;
            response.code = InterfaceResponseCode.InterfaceInexistence;
            response.data = null;
            return response;
        }

        if (interfaceInfo.isSync === true) {
            let impl = interfaceInfo.impl;
            response.success = true;
            response.code = InterfaceResponseCode.Success;
            response.data = impl(params);
            return response;
        } else {
            response.success = false;
            response.code = InterfaceResponseCode.InterfaceTypeException;
            response.data = null;
            return response;
        }
    }


    invokeAsyncInterface = (invokeInfo: InvokeInterfaceInfo, params: any) => {
        let response = new InterfaceResponse();

        let classInfo = this.interfaceBook.get(invokeInfo.className);
        let interfaceInfo: InterfaceInfo = null;

        if (classInfo) {
            interfaceInfo = classInfo.get(invokeInfo.interfaceName);
        }

        if (!interfaceInfo) {
            response.success = false;
            response.code = InterfaceResponseCode.InterfaceInexistence;
            response.data = null;
            this.invokeAsyncInterfaceCallback(invokeInfo, response);
            return;
        }

        if (interfaceInfo.isSync === true) {
            response.success = false;
            response.code = InterfaceResponseCode.InterfaceTypeException;
            response.data = null;
            this.invokeAsyncInterfaceCallback(invokeInfo, response);
            return;
        } 

        let impl = interfaceInfo.impl;
        let callback = (data: any) => {
            response.success = true;
            response.code = InterfaceResponseCode.Success;
            response.data = data;
            this.invokeAsyncInterfaceCallback(invokeInfo, response);
        }

        impl(params, callback);
    }

    registerInterfaceToNative = (className: string, interfaceName: string, isSync: boolean) => {
        this.jsNativeLinkCore.invokeNativeMethod({ 'className': this.className, 'methodName': "registerInterfaceToNative" }, { 'className': className, 'interfaceName': interfaceName, 'isSync': isSync });
    }

    invokeAsyncInterfaceCallback = (invokeInfo: InvokeInterfaceInfo, response: InterfaceResponse) => {
        this.jsNativeLinkCore.invokeNativeMethod({ 'className': this.className, 'methodName': "invokeAsyncInterfaceCallback" }, { 'invokeInfo': invokeInfo, 'response': response });
    }

}
