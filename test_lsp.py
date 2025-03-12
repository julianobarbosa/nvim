from typing import List, Optional

class Calculator:
    def __init__(self):
        self.history: List[float] = []
    
    def add(self, a: float, b: float) -> float:
        result = a + b
        self.history.append(result)
        return result
    
    def get_last_result(self) -> Optional[float]:
        return self.history[-1] if self.history else None

# Intentional issues to test LSP features:
calc = Calculator()
result = calc.add("1", 2)  # Type error: Expected float, got str
unused_var = 10  # Unused variable warning (flake8)
import os, sys  # Import formatting issue (isort)