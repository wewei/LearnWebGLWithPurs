export const once = (f) => () => {
  let g = f;
  return (a) => () => {
    if (g) {
      g = null;
      g(a)();
    }
  };
};
