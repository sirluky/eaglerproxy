export const config = {
  bindInternalServerPort: parseInt(process.env.EAGPROXYAAS_INTERNAL_PORT || "25569"),
  bindInternalServerIp: process.env.EAGPROXYAAS_INTERNAL_IP || "127.0.0.1",
  allowCustomPorts: process.env.ALLOW_CUSTOM_PORTS !== "false",
  allowDirectConnectEndpoints: process.env.ALLOW_DIRECT_CONNECT !== "false",
  disallowHypixel: process.env.DISALLOW_HYPIXEL === "true",
  showDisclaimers: process.env.SHOW_DISCLAIMERS === "true",
  authentication: {
    enabled: process.env.AUTH_ENABLED === "true",
    password: process.env.AUTH_PASSWORD || "nope",
  },
};
