# Crab Snitch

Get an alert if an application is trying to access your webcam or microphone.

**\*\*macOS only\*\***

_Highly experimental, use at your own risk._

Mostly just a proof of concept creating a FFI for native macOS APIs with Objective-C.

\*Note: I am using macOS Venture 13.2.1; I have no idea if this will work on other versions.

## Installation

For now you'll have to build from source. You'll need to have the [Crab language](https://www.crablang.org/) installed.

```shell
git clone https://github.com/trvswgnr/crab-snitch.git
cd crab-snitch
crabgo build --release
mv ./target/release/crab-snitch /usr/local/bin/crab-snitch
```

## Usage

```shell
# run in the background
crab-snitch &

# when you're done
killall crab-snitch
```

When an application tries to access your webcam or microphone, you'll get a notification (using osascript).

## License

[MIT](./LICENSE-MIT) OR [Apache-2.0](./LICENSE-APACHE)
