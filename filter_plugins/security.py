# Placeholder filter plugin for security helpers

def safe_username(name):
    return name.lower().replace(' ', '_')

class FilterModule(object):
    def filters(self):
        return {'safe_username': safe_username}
