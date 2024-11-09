Config = {}

Config.Debug = true

-- List of job names considered as police jobs
Config.PoliceJobs = {
    'lspd',        -- Default job name for police
    'bcso',       -- Additional job name for sheriff deputies
    'sasp',     -- State police job name
    'lsfd'    -- Fire department job name
}

-- Notification settings, if any specific configurations are required
Config.NotificationSettings = {
    enableLogging = true,     -- Enable logging for debug purposes
    notificationInterval = 5000  -- Time in milliseconds between checking for new incidents
}