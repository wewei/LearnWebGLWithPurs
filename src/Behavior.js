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

export const pure_Behavior = (a) => (_) => a;

export const map_Behavior = (f) => (bhA) => behavior(cbl => f(bhA(cbl)));

export const apply_Behavior = (bhF) => (bhA) => behavior(cbl => bhF(cbl)(bhA(cbl)));

export const bind_Behavior = (bhA) => (f) => behavior(cbl => f(bhA(cbl))(cbl));

export const subscribe_Behavior = (bhA) => (hdl) => () => {
    let cb = () => cb && (hdl(bhA(cb))(), undefined);
    hdl(bhA(cb))();
    return () => { cb = null; };
};

export const observe = (bhA) => () => bhA(() => {});

export const counter = (interval) => () => {
    const start = Date.now();
    return behavior((cb) => {
        const elapsed = Date.now() - start;
        const val = Math.floor(elapsed / interval);
        const ms = (val + 1) * interval - elapsed;
        setTimeout(cb, ms);
        return val;
    });
};

export const pure_Pulse = (a) => (cb) => cb(a);

export const map_Pulse = (f) => (psA) => (cb) => psA(a => cb(f(a)));

// apply :: m (a -> b) -> m a -> m b
// bind :: m a -> (a -> m b) -> m b
// apply mF mA = bind mF (\f -> map f mA)
// 
// export const apply_Pulse = (psF) => (psA) => 
// map = \f psA cb -> psA (\a -> cb (f a))
// apply = \psF psA cb -> psF (\f -> psA (\a -> cb (f a)))
// bind = \psA f cb -> psA (\a -> f a cb)
//    apply psF psA
// b= bind psF (\f -> map f psA)
// b= bind psF (\f -> (\f psA cb -> psA (\a -> cb (f a))) f psA)
// b= bind psF (\f -> (\cb -> psA (\a -> cb (f a))))
// b= (\psA f cb -> psA (\a -> f a cb)) psF (\f -> (\cb -> psA (\a -> cb (f a))))
// b= (\f cb -> psF (\a -> f a cb)) (\f -> (\cb -> psA (\a -> cb (f a))))
// b= \cb -> psF (\a -> (\f -> (\cb -> psA (\a -> cb (f a)))) a cb)
// a= \cb -> psF (\g -> (\f -> (\cb -> psA (\a -> cb (f a)))) g cb)
// b= \cb -> psF (\g -> (\cb -> psA (\a -> cb (g a))) cb)
// b= \cb -> psF (\g -> psA (\a -> cb (g a)))
// a= \cb -> psF (\f -> psA (\a -> cb (f a)))
// <=>
// apply = \psF psA cb -> psF (\f -> psA (\a -> cb (f a)))

export const apply_Pulse = (psF) => (psA) => (cb) => psF(f => psA(a => cb(f(a))))

export const bind_Pulse = (psA) => (f) => (cb) => psA(a => f(a)(cb));

export const subscribe_Pulse = (psA) => (hdl) => () => {
    let cb = (a) => cb && (psA(cb), hdl(a)(), undefined);
    psA(cb);
    return () => { cb = null; };
};

export const once = (psA) => (hdl) => () => psA(a => hdl(a)());

export const integral = (f) => (psA) => (b) => () => {
    let val = b;
    return behavior(cb => {
        psA(a => {
            const newValue = f(a)(val);
            if (newValue !== val) {
                val = newValue;
                cb();
            }
        });
        return val;
    });
};

export const differential = (f) => (bhA) => (cb) => {
    let val;
    const callback = () => {
        console.log("get here");
        const oldVal = val;
        val = bhA(callback);
        cb(f(oldVal)(val));
    };
    val = bhA(callback);
};
