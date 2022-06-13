from libqtile.layout import Tile

class CustomTile(Tile):
    def configure(self, client, screen_rect):
        screen_width = screen_rect.width
        screen_height = screen_rect.height
        border_width = self.border_width
        if self.clients and client in self.clients:
            pos = self.clients.index(client)
            if client in self.master_windows:
                w = int(screen_width * self.ratio_size) \
                    if len(self.slave_windows) or not self.expand \
                    else screen_width
                h = screen_height // self.master_length
                x = screen_rect.x
                y = screen_rect.y + pos * h
            else:
                w = screen_width - int(screen_width * self.ratio_size)
                h = screen_height // (len(self.slave_windows))
                x = screen_rect.x + int(screen_width * self.ratio_size)
                y = screen_rect.y + self.clients[self.master_length:].index(client) * h
            if client.has_focus:
                bc = self.border_focus
            else:
                bc = self.border_normal
            if not self.border_on_single and len(self.clients) == 1:
                border_width = 0
            else:
                border_width = self.border_width
            
            client.place(
                x,
                y,
                w,
                h,
                border_width,
                bc,
                margin=0 if (not self.margin_on_single and len(self.clients) == 1) else self.margin,
            )
            client.unhide()
        else:
            client.hide()
