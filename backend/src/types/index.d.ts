export {}

declare global {
  namespace Express {
    interface Response {
      aggregatedResults: any
    }
    interface Request {
      aggregatedResults: any
    }
  }
}