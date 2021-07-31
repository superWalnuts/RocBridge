
export type InterfaceCallback = (response: any) => void;

export type InterfaceImplementation = (parameter: Map<string, any>, callback: InterfaceCallback) => any | void;
