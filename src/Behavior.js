export const pure_Behavior = (a) => (_) => a;

const behavior = (getVal) => {
    let ctx = null;
    return (cb) => {
        if (!ctx) {
            const cbl = () => {
                if (ctx && ctx.cbl === cbl) {
                    const { cbs } = ctx;
                    ctx = null;
                    for (let cbT of cbs) {
                        cbT();
                    }
                }
            };
            ctx = { cbs: [], cbl, val: getVal(cbl) };
        }
        const { cbs, val } = ctx;
        cbs.push(cb);
        return val;
    };
};

export const map_Behavior = (f) => (bhA) => behavior(cbl => f(bhA(cbl)));

export const apply_Behavior = (bhF) => (bhA) => behavior(cbl => bhF(cbl)(bhA(cbl)));

export const bind_Behavior = (bhA) => (f) => behavior(cbl => f(bhA(cbl))(cbl));

export const observe = (bhA) => (hdl) => {
    let cb = () => cb && hdl(bhA(cb))();
    hdl(bhA(cb))();
    return () => { cb = null; };
};

export const peek = (bhA) => () => bhA(() => {});

export const counter = (interval) => () => {
    const start = Date.now();
    return (cb) => {
        const elapsed = Date.now() - start;
        const val = Math.floor(elapsed / interval);
        const ms = (val + 1) * interval - elapsed;
        setTimeout(cb, ms);
        return val;
    };
};
