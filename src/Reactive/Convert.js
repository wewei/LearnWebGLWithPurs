import { diff, accum as accumImpl } from "@node-frp/core";

export { diff };
export const accum = (f) => (ser) => b => () => accumImpl(f)(ser)(b);