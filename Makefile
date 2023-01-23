GO ?= go

build:
	$(GO) build -o plugins/bin/debug-cni cmd/debug-cni.go
