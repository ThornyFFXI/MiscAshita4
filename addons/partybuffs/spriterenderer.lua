local sprite_ptr = ffi.new('ID3DXSprite*[1]');
if (ffi.C.D3DXCreateSprite(d3d8_device, sprite_ptr) ~= ffi.C.S_OK) then
    error('failed to make sprite obj');
end
local sprite = d3d8.gc_safe_release(ffi.cast('ID3DXSprite*', sprite_ptr[0]));
local rect = ffi.new('RECT', { 0, 0, 32, 32, });
local vec_position = ffi.new('D3DXVECTOR2', { 0, 0, });
local vec_scale = ffi.new('D3DXVECTOR2', { 1.0, 1.0, });

local renderer = {};

function renderer:Begin()
    sprite:Begin();
end

function renderer:Draw(texture, x, y, scale)
    vec_scale.x = scale;
    vec_scale.y = scale;
    vec_position.x = x;
    vec_position.y = y;
    sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, 0xFFFFFFFF);
end

function renderer:End()
    sprite:End();
end

return renderer;