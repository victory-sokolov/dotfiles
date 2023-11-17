import ast
import sys

def find_test_methods(file_path: str) -> list[str]:
    class_name = None
    test_methods = []

    def visit_FunctionDef(node):
        if node.name.startswith('test_') and class_name:
            test_methods.append(f'{class_name}.{node.name}')

    def visit_ClassDef(node):
        nonlocal class_name
        class_name = node.name
        class_methods = [method.name for method in node.body if isinstance(method, ast.FunctionDef) and method.name.startswith('test_')]
        test_methods.extend([f'{class_name}.{method}' for method in class_methods])

    with open(file_path, 'r') as file:
        tree = ast.parse(file.read(), filename=file_path)

        for node in tree.body:
            if isinstance(node, ast.ClassDef):
                visit_ClassDef(node)
                class_name = None
            elif isinstance(node, ast.FunctionDef):
                visit_FunctionDef(node)

    return test_methods


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(1)

    test_file_path = sys.argv[1]
    test_methods = find_test_methods(test_file_path)
    print("\n".join(test_methods))
