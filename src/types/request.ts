import { Request } from "express"


export interface AgencyRequest extends Request {
  agencyId?: string
  doc?: any
}


export interface UserRequest extends Request {
  userId?: string
  doc?: any
}
