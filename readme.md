# RANKS
Import the ``import.sql`` file into your database

This resource is for developers/server owners who want to be able to restrict certain things for their users until they reach a certain rank. By itself it will keep track of the ranking of your team. To get the most out of it you will need to code it into a resource based around an if statement. Almost the whole resource is server sided and I may add a hud feature in the future if it's requested. At the moment I don't want to clutter the user screen with yet another hud element.

## Dependencies
This resource **REQUIRES** NAT2K15's framework to work properly.

## Features
+ Has exports to get the rank of a specific user so that you can restrict certain functions to a minimum rank, specific rank, or anything inbetween.
+ Expandable config options to change the department names and names of ranks
+ Uses the frameworks discord webhook to notify you when a users rank has changed.
+ Sends chat to the person granting the rank and the person receiving the rank to ensure everything worked smothly.

---
## Commands
- rank
    - checks rank
- promote [sid]
    - promotes target player
- demote [sid]
    - demotes target player
- setrank [sid] [rank]
    - set the rank of the target player

## Exports
All Exports are server sided.

---
### getallranks
> exports.ranks:getallranks()
> - will return the entire "rank" table. elements in this table include: "num", "name", and "dept"

**EXAMPLE**

``` 
function dostuff(src)
    local rank = exports.ranks.getallranks()
    if (rank[src].num >= 10) then --Src needs to be defined as it pulls for a specific person
        "do things that you want anyone greater than rank 10 to do"
    end
end
```
---
### GetRank
> exports.ranks:GetRank(src: number)
> - will return the entire "rank" table for a **single person**. elements in this table include: "num", "name", and "dept"

**EXAMPLE**

``` 
function dostuff(src)
    local rank = exports.ranks.GetRank(src)
    if (rank.num >= 10) then --Src needs to be defined as it pulls for a specific person
        "do things that you want anyone greater than rank 10 to do"
    end
end
```
---
### SetRank
> exports.ranks:SetRank(from: number, to: number, rank: number, type: string)
> - will update the rank of a given player. 
> - from: server id of the person doing the promoting
> - to: server id of the person being promoted
> - rank: rank number to be passed (set to 'nil' if type is set to promote, or demote. Promote and demote will automatically change the rank by 1.) 
> - type: can be set to "set", "promote", or "demote")

**EXAMPLE**

``` 
function updaterank()
    local player = GetPlayerServerID()
    local target = GetPlayerServerID(target)
    exports.ranks:SetRank(player, target, 'nil', 'promote')
end
```
