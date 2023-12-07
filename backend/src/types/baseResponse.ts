export class BaseResponse {
  data: object = {};
  success: boolean = false;
  message: string = "";
  errors: [any] = [null];
}
