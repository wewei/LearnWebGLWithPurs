import {
  cachedBehavior,
  pureBehavior,
  mapBehavior,
  applyBehavior,
  bindBehavior,
  peekBehavior as peekBehaviorImpl,
  observeBehavior as observeBehaviorImpl,
  mapSeries,
  observeSeries as observeSeriesImpl,
  accum as accumImpl,
  diff,
} from "@node-frp/core";

export  { pureBehavior, mapBehavior, applyBehavior, bindBehavior, mapSeries, diff };

export const observeBehavior = (beh) => (hdl) => () =>
  observeBehaviorImpl(beh)((val) => hdl(val)());

export const peekBehavior = beh => () => peekBehaviorImpl(beh);
