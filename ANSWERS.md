# Short answers — Z-Transform Problem Assignment

## Part 1 — A signal and its Z-transform

**1. Identify each term in X(z).**  `1` represents `x[0] = 1`; `2z^(-1)` represents `x[1] = 2`; and `z^(-2)` represents `x[2] = 1`. In the Z-transform sum, a sample at index `n` contributes `x[n]z^(-n)`.

**2. Z-transform of the delayed signal.** A one-sample delay gives `xDelayed = [0 1 2 1]` for `n = 0, 1, 2, 3`. Thus `X_delayed(z) = z^(-1) + 2z^(-2) + z^(-3)`.

**3. Why is X(z) multiplied by z^(-1)?** Each original value moves from index `n` to `n+1`. Its power changes from `z^(-n)` to `z^(-(n+1))`, which adds one common factor of `z^(-1)` to every term. This uses a causal signal with zero prehistory.

## Part 2 — A system with one-sample delay

**4. Calculate outputs manually.** With `y[n] = 0.5x[n] + 0.5x[n-1]` and `x[-1] = x[3] = 0`:

- `y[0] = 0.5(1) + 0.5(0) = 0.5`.
- `y[1] = 0.5(2) + 0.5(1) = 1.5`.
- `y[2] = 0.5(1) + 0.5(2) = 1.5`.
- `y[3] = 0.5(0) + 0.5(1) = 0.5`.

The expected MATLAB `filter` output is `[0.5 1.5 1.5 0.5]`.

**5. Meaning of b = [0.5 0.5].** The first coefficient multiplies the current input `x[n]`, corresponding to the constant term `0.5` of `H(z)`. The second coefficient multiplies the previous input `x[n-1]`, corresponding to `0.5z^(-1)`.

**6. Change to H(z) = 0.8 + 0.2z^(-1).** Use `b = [0.8 0.2]`, giving the expected output `[0.8 1.8 1.2 0.2]`. The present input `x[n]` has more influence because it is weighted `0.8`, versus `0.2` for the previous input.

## Experiment limitation
This exercise demonstrates two short finite-length FIR responses with zero initial conditions. It does not establish broader performance on real signals.
