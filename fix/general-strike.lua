local argparse = require('argparse')

-- sometimes, planted seeds lose their 'in_building' flag. This causes massive
-- amounts of job cancellation spam as everyone tries, then fails, to re-plant
-- the seeds.
local function fix_seeds(quiet)
    local count = 0
    for _,v in ipairs(df.global.world.items.other.SEEDS) do
        if not v.flags.in_building and
                (dfhack.items.getGeneralRef(v, df.general_ref_type.BUILDING_HOLDER)) then
            v.flags.in_building = true
            count = count + 1
        end
    end
    if not quiet or count > 0 then
        print(('fixed %d seed(s)'):format(count))
    end
end

local function main(args)
    local help = false
    local quiet = false
    local positionals = argparse.processArgsGetopt(args, {
        {'h', 'help', handler=function() help = true end},
        {'q', 'quiet', handler=function() quiet = true end},
    })

    if help or positionals[1] == 'help' then
        print(dfhack.script_help())
        return
    end

    fix_seeds(quiet)
end

main{...}
