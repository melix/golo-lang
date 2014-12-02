import groovy.transform.CompileStatic

@CompileStatic
class FibonacciPrimitiveCS {

    static long fib(long n) {
        n <= 2L ? 1L : fib(n - 1L) + fib(n - 2L)
    }
}