def greet(name: str) -> None:
    print(f"Hello, {name}!")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Greet by name")
    parser.add_argument("--name", default="World", help="name to greet")
    args = parser.parse_args()

    greet(args.name)
