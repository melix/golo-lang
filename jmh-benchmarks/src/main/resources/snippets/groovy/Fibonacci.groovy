class Fibonacci {

    static def fib(n) {
        n <= 2L ? 1L : fib(n - 1L) + fib(n - 2L)
    }
}