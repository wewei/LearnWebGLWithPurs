import { cachedBehavior } from "@node-frp/core";

export const counter = (interval) => () => {
  const start = Date.now();
  return cachedBehavior((cb) => {
    const elapsed = Date.now() - start;
    const val = Math.floor(elapsed / interval);
    const ms = (val + 1) * interval - elapsed;
    setTimeout(cb, ms);
    return val;
  });
};

