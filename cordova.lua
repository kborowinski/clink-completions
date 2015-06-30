--preamble: common routines

local function platforms(token)
    local res = {}
    local platforms = clink.find_dirs('platforms/*')
    for _,platform in ipairs(platforms) do
        if platform:find("%.+$") == nil and platform:match(token) then
            table.insert(res, platform)
        end
    end
    return res
end

local function plugins(token)
    local res = {}
    local plugins = clink.find_dirs('plugins/*')
    for _,plugin in ipairs(plugins) do
        if plugin:find("%.+$") == nil and plugin:match(token) then
            table.insert(res, plugin)
        end
    end
    return res
end

-- end preamble

local parser = clink.arg.new_parser

local platform_add_parser = parser({
    "wp8",
    "windows",
    "android",
    "blackberry10",
    "firefoxos",
    dir_match_generator
}, "--usegit", "--save", "--link"):loop(1)

local plugin_add_parser = parser({dir_match_generator,
        "org.apache.cordova.battery-status", "cordova-plugin-battery-status",
        "org.apache.cordova.camera", "cordova-plugin-camera",
        "org.apache.cordova.contacts", "cordova-plugin-contacts",
        "org.apache.cordova.device", "cordova-plugin-device",
        "org.apache.cordova.device-motion", "cordova-plugin-device-motion",
        "org.apache.cordova.device-orientation", "cordova-plugin-device-orientation",
        "org.apache.cordova.dialogs", "cordova-plugin-dialogs",
        "org.apache.cordova.file", "cordova-plugin-file",
        "org.apache.cordova.file-transfer", "cordova-plugin-file-transfer",
        "org.apache.cordova.geolocation", "cordova-plugin-geolocation",
        "org.apache.cordova.globalization", "cordova-plugin-globalization",
        "org.apache.cordova.inappbrowser", "cordova-plugin-inappbrowser",
        "org.apache.cordova.media", "cordova-plugin-media",
        "org.apache.cordova.media-capture", "cordova-plugin-media-capture",
        "org.apache.cordova.network-information", "cordova-plugin-network-information",
        "org.apache.cordova.splashscreen", "cordova-plugin-splashscreen",
        "org.apache.cordova.vibration", "cordova-plugin-vibration"
    },
    "--searchpath" ..parser({dir_match_generator}),
    "--noregistry",
    "--link",
    "--save",
    "--shrinkwrap"
):loop(1)

local platform_rm_parser = parser({platforms}, "--save"):loop(1)
local plugin_rm_parser = parser({plugins}, "-f", "--force", "--save"):loop(1)

local cordova_parser = parser(
    {
        -- common commands
        "create" .. parser(
            "--copy-from", "--src",
            "--link-to"
        ),
        "help",
        -- project-level commands
        "info",
        "platform" .. parser({
            "add" .. platform_add_parser,
            "remove" .. platform_rm_parser,
            "rm" .. platform_rm_parser,
            "list", "ls",
            "up" .. parser({platforms}):loop(1),
            "update" .. parser({platforms}, "--usegit", "--save"):loop(1),
            "check"
            }),
        "plugin" .. parser({
            "add" .. plugin_add_parser,
            "remove" .. plugin_rm_parser,
            "rm" .. plugin_rm_parser,
            "list", "ls",
            "search"
        }, "--browserify"),
        "prepare" .. parser({platforms}, "--browserify"):loop(1),
        "compile" .. parser({platforms},
            "--debug", "--release",
            "--device", "--emulator", "--target="):loop(1),
        "build" .. parser({platforms},
            "--debug", "--release",
            "--device", "--emulator", "--target="):loop(1),
        "run" .. parser({platforms},
            "--nobuild",
            "--debug", "--release",
            "--device", "--emulator", "--target="),
        "emulate" .. parser({platforms}),
        "serve",
    }, "-h",
    "-v", "--version",
    "-d", "--verbose")

clink.arg.register_parser("cordova", cordova_parser)
clink.arg.register_parser("cordova-dev", cordova_parser)
