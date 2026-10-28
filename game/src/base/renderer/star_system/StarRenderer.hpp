#ifndef STAR_SYSTEM_STAR_RENDERER_HPP_
#define STAR_SYSTEM_STAR_RENDERER_HPP_

#include <enginecore/core/CoreDefines.h>

#include <unordered_map>

#define GLM_ENABLE_EXPERIMENTAL
#include <glm/gtx/quaternion.hpp>

#include <enginecore/core/EngineCoreApplication.h>

#include <enginecore/core/graphics/render/ModelRenderer.h>
#include <enginecore/core/graphics/render/Batch3D.h>

#include "base/world/World.h"
#include "base/renderer/Renderer.hpp"

class StarRenderer : public Renderer
{
public:
    StarRenderer(const std::weak_ptr<World>& world);
    ~StarRenderer() = default;

public:
    void render();

private:
    void prepareShaders();

private:
    std::unique_ptr<Batch3D> m_batch;
};

#undef GLM_ENABLE_EXPERIMENTAL

#endif // STAR_SYSTEM_STAR_RENDERER_HPP_
