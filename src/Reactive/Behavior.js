import { behavior } from "@node-frp/core";
export {
  pureBehavior,
  mapBehavior,
  applyBehavior,
  bindBehavior,
  peekBehavior,
  observeBehavior,
  mapSeries,
  diff,
} from "@node-frp/core";

export const deflickerImpl = (eq) => (beh) => behavior((eff) => {
  let inv = () => {
    if (inv && !eq(val)(beh(inv))) {
      inv = null;
      eff();
    }
  };
  const val = beh(inv);
  return val;
});