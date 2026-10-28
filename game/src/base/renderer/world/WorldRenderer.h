#pragma once
#ifndef RENDER_WORLDRENDERER_H_
#define RENDER_WORLDRENDERER_H_

#include <unordered_map>

#define GLM_ENABLE_EXPERIMENTAL
#include <glm/gtx/quaternion.hpp>

#include <enginecore/core/EngineCoreApplication.h>

#include <enginecore/core/graphics/render/ModelRenderer.h>

#include "base/world/World.h"
#include "base/renderer/Renderer.hpp"
#include "base/renderer/star_system/StarRenderer.hpp"

class WorldRenderer : public Renderer
{
public:
    WorldRenderer(const std::weak_ptr<World>& world);
    ~WorldRenderer() = default;

public:
    void render();

private:
    void prepareShaders();

private:
    std::shared_ptr<ModelRenderer> m_model_renderer;
    std::shared_ptr<StarRenderer> m_star_renderer;
};

#undef GLM_ENABLE_EXPERIMENTAL

#endif // !RENDER_WORLDRENDERER_H_