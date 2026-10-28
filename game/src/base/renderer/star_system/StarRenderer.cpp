#include "StarRenderer.hpp"

StarRenderer::StarRenderer(const std::weak_ptr<World> &world)
    : Renderer(world), m_batch(std::make_unique<Batch3D>(1024))
{
}

void StarRenderer::render()
{
    prepareShaders();

    m_batch->begin();
    m_batch->setColor(200, 60, 60);
    m_batch->cube({0, 0, 0}, 1.0f);
    m_batch->sphere({3, 1, 0}, 0.5f, 16, 16);
    m_batch->flush();
}

void StarRenderer::prepareShaders()
{
}
