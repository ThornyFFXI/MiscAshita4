local gui = {
    visible = { false };
    SelectedUser = nil,
    SelectedTerm = nil,
    UserBuffer = { '' },
    TermBuffer = { '' },
}
local header = { 1.0, 0.75, 0.55, 1.0 };
local imgui = require('imgui');

function gui:tick()
    if self.visible[1] ~= true then
        return;
    end

    if (imgui.Begin(string.format('%s v%.2f##CleanupGUI', addon.name, addon.version), self.visible, ImGuiWindowFlags_AlwaysAutoResize)) then
        if imgui.BeginTabBar('##CleanupTabBar', ImGuiTabBarFlags_NoCloseWithMiddleMouseButton) then
            if imgui.BeginTabItem('Users##CleanupUserTab') then
                imgui.TextColored(header, 'Blocked Users');
                imgui.BeginChild('pane', { 450, 280 }, ImGuiChildFlags_Borders);
                local users = T{};
                for user,_ in pairs(settings.Names) do
                    users:append(user)
                end
                table.sort(users)
                for _,name in ipairs(users) do
                    if imgui.Selectable(name, self.SelectedUser == name) then
                        self.SelectedUser = name
                    end
                    if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                        settings.Names[name] = nil;
                        WriteSettings(settings, true)
                        print(chat.header('CleanUp') .. chat.message(string.format('Removed %s from block list.', name)));
                    end
                end
                imgui.EndChild();
                local save = false;
                if imgui.InputText('##BlackListUser', self.UserBuffer, 256, ImGuiInputTextFlags_EnterReturnsTrue) then
                    save = true;
                end
                imgui.SameLine();
                if imgui.Button('Block##BlackListUserButton') then
                    save = true;
                end
                if save then
                    local name = string.upper(string.sub(self.UserBuffer[1], 1, 1)) .. string.lower(string.sub(self.UserBuffer[1], 2));
                    if settings.Names[name] ~= true then
                        settings.Names[name] = true;
                        WriteSettings(settings, true);
                        print(chat.header('CleanUp') .. chat.message(string.format('Added %s to block list.', name)));
                        self.UserBuffer[1] = ''
                    end
                end
                imgui.EndTabItem();
            end

            if imgui.BeginTabItem('Terms##CleanupTermsTab') then
                imgui.TextColored(header, 'Blocked Terms');
                imgui.BeginChild('pane', { 450, 280 }, ImGuiChildFlags_Borders);
                local deleted = T{}
                for _,term in ipairs(settings.Terms) do
                    if imgui.Selectable(term, self.SelectedTerm == term) then
                        self.SelectedTerm = term
                    end
                    if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                        deleted:append(term);
                        print(chat.header('CleanUp') .. chat.message(string.format('Removed %s from term filter.', term)));
                    end
                end
                imgui.EndChild();
                if #deleted > 0 then
                    settings.Terms = settings.Terms:filteri(function(term) return not deleted:contains(term) end);
                    WriteSettings(settings, true)
                end

                local save = false;
                if imgui.InputText('##BlackListTerm', self.TermBuffer, 256, ImGuiInputTextFlags_EnterReturnsTrue) then
                    save = true;
                end
                imgui.SameLine();
                if imgui.Button('Block##BlacklistTermButton') then
                    save = true;
                end
                if save then
                    settings.Terms:append(self.TermBuffer[1]);
                    WriteSettings(settings, true);
                    print(chat.header('CleanUp') .. chat.message(string.format('Added %s to term list.', self.TermBuffer[1])));
                    self.TermBuffer[1] = '';
                end
                imgui.EndTabItem();
            end
            imgui.EndTabBar();
        end
    end
    imgui.End();
end

function gui:show()
    gui.visible[1] = true
end

ashita.events.register('d3d_present', 'Cleanup_HandleRender', function ()
    gui:tick();
end);

return gui;