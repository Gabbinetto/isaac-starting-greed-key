local mod = RegisterMod("Starting key in greed", 1)
local game = Game()
local coinsPrevented = 0
local keyCost = 5

function mod:PostGameStarted(isContinued)
    local level = game.GetLevel(game)
    local stage = level.GetStage(level)
    local player = Isaac.GetPlayer()
    coinsPrevented = 0
    if stage == LevelStage.STAGE1_GREED and game.IsGreedMode(game) then
        player.AddKeys(player, 1)
    end
end

function mod:PreEntitySpawn(entityType, variant, subType, position, velocity, spawner, seed)
    if entityType == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COIN and subType == CoinSubType.COIN_PENNY then
        local level = game.GetLevel(game)
        local stage = level.GetStage(level)
        local room = game.GetRoom(game)
        if stage == LevelStage.STAGE1_GREED and coinsPrevented < keyCost and room.GetType(room) == RoomType.ROOM_DEFAULT and game.IsGreedMode(game) then
            coinsPrevented = coinsPrevented + 1
            return { EntityType.ENTITY_EFFECT, EffectVariant.POOF01 }
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, mod.PreEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.PostGameStarted)
