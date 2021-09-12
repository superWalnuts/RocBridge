import { BaseManager } from "../base/base-manager";
import { JSMethod, JSMethodInfo, NativeMethodInfo } from "../base/base-type";
import { ManagerGroup } from "../base/manager-group";


export class JsNativeLinkCore {

    jsMethodBook: Map<string, Map<string, JSMethod>> = new Map();

    constructor(){
        window['invokeJSMethod'] = this.invokeJSMethod;
    }

    invokeNativeMethod = (nativeMethodInfo: NativeMethodInfo, params: any) => {

        let func = window['invokeNativeMethod'];

        if (!func) {
            throw 'InvokeNativeMethod must be implemented in Native.'
        }

        if (!(func instanceof Function)) {
            throw 'InvokeNativeMethod must be a Function.'
        }

        return func(nativeMethodInfo, params);

    }

    invokeJSMethod = (jsMethodInfo: JSMethodInfo, params: any) => {
        if (!jsMethodInfo.className || !jsMethodInfo.methodName) {
            return undefined;
        }

        let classInfo = this.jsMethodBook.get(jsMethodInfo.className);

        if (!classInfo) {
            return undefined;
        }

        let func= classInfo.get(jsMethodInfo.methodName);

        if (!func) {
            return undefined;
        }

        return func(params);
    }

    regsiterJsMethod = (jsMethodInfo: JSMethodInfo, jsMethod: JSMethod) => {
        if (!jsMethodInfo.className || !jsMethodInfo.methodName) {
            return false;
        }

        let classInfo = this.jsMethodBook.get(jsMethodInfo.className);
        if (!classInfo) {
            classInfo = new Map();
        }

        classInfo.set(jsMethodInfo.methodName, jsMethod);
        this.jsMethodBook.set(jsMethodInfo.className, classInfo);
        return true;
    }

}