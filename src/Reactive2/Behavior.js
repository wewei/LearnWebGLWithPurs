export const once = (f) => () => {
  let g = f;
  return (a) => () => {
    if (g) {
      g = null;
      g(a)();
    }
  };
};

// export const memoizeBehavior = (fst, snd) => (f) => {
//   let ctx = null;
//   return () => {
//     if (!ctx) {
//       const tpl = f();
//       const val = fst(tpl);
//       const fut = snd(tpl);
//       const cbs = [];
//       ctx = { val, fut, cbs };
//     }
//   }

// }