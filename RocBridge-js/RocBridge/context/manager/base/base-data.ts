
export enum InterfaceResponseCode
{
    Error = -1,
    Success = 0,
    ParameterIllegal = -1,
    InterfaceInexistence = -2,
    EventUnregistered = -3,
    InterfaceTypeException = -4
}

export class InterfaceResponse
{
    success: boolean
    code: InterfaceResponseCode
    data: any 
}