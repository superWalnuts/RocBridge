
export type InterfaceCallback = (response: any) => void;

export type InterfaceImplementation = (parameter: Map<string, any>, callback?: InterfaceCallback) => any | void;

export interface InvokeInterfaceInfo { className: string, interfaceName: string, sync: boolean };

export interface InterfaceInfo { impl: InterfaceImplementation, isSync: boolean };

export interface NativeMethodInfo { className: string, methodName: string };

export interface JSMethodInfo { className: string, methodName: string };

export type JSMethod = (parames: any) => any | void;
