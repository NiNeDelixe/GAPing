#include "WorldRenderer.h"

WorldRenderer::WorldRenderer(const std::weak_ptr<World>& world)
	: Renderer(world)
{
	m_model_renderer = std::make_shared<ModelRenderer>();
	m_star_renderer = std::make_shared<StarRenderer>(world);
}

void WorldRenderer::render()
{
	if (auto world = m_world.lock(); !world || !world->hasLevel())
    {
        return;
    }

    prepareShaders();


    m_model_renderer->render();
    m_star_renderer->render();
}

void WorldRenderer::prepareShaders()
{
	const auto& shader = EngiApp->assets().lock()->get<GLShader>("camera");
    const auto& camera_views = EngiApp->getEntityRegistry().view<Camera, RenderTransform>();
    //const auto& model_views = EngiApp->getEntityRegistry().view<const ModelComponent, Transform>();
    const auto& viewport = EngiApp->window()->viewports()[0];
    
    for (auto&& [camera_entity, camera, camera_transform] : camera_views.each())
    {
        glm::mat4 model = glm::translate(glm::mat4(1.0f)/*base*/, camera_transform.relative_position/*pos*/);
        model *= glm::toMat4(camera_transform.relative_rotation);

        camera.setAspectRatio(viewport->getWidth() / static_cast<float>(viewport->getHeight()));
        //camera.setAspectRatio(viewport->getHeight() / static_cast<float>(viewport->getWidth()));

        shader->use();
        //frag
        //shader->uniform("u_lightDirection", glm::vec3(1));
        //shader->uniform("u_baseColor", glm::vec3(1));
        shader->uniform("u_color", glm::vec4(1.f));

        //vert
        shader->uniform("u_model", model);
        shader->uniform("u_projection", camera.getProjection());
        shader->uniform("u_view", camera.getView());
        //shader->uniform("u_normal", glm::mat3(1));
    }
}
