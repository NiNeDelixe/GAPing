#ifndef RENDERER_RENDERER_HPP_
#define RENDERER_RENDERER_HPP_

#include <enginecore/core/CoreDefines.h>


#include "base/world/World.h"

class Renderer
{
public:
    Renderer(const std::weak_ptr<World>& world)
        : m_world(world) {}
    ~Renderer() = default;

protected:
    std::weak_ptr<World> m_world;

};

#endif // RENDERER_RENDERER_HPP_
