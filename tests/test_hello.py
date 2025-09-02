from hello import greet

def test_greet_prints_yamaguchi(capsys):
    greet("Yamaguchi")
    captured = capsys.readouterr()
    assert captured.out.strip() == "Hello, Yamaguchi!"