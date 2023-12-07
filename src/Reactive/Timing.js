import { behavior } from "@node-frp/core";

export const counter = (interval) => () => {
  const start = Date.now();
  return behavior((cb) => {
    const elapsed = Date.now() - start;
    const val = Math.floor(elapsed / interval);
    const ms = (val + 1) * interval - elapsed;
    console.log('get here', interval);
    setTimeout(cb, ms);
    return val;
  });
};

