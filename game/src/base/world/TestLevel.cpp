#include "TestLevel.h"

#include <enginecore/core/ecs/components/PlayerComponent.h>
#include <enginecore/core/ecs/components/physics/GravityComponent.h>
#include <enginecore/core/ecs/components/physics/RigidBodyComponent.h>
#include <enginecore/core/ecs/components/transform/RenderTransform.h>
#include <enginecore/core/ecs/components/ModelComponent.h>

#include "base/ecs/components/space_transform/FloatingOrigin.h"
//#include "base/ecs/components/RenderTransform.h"
#include "base/ecs/components/space_transform/SpaceTransform.h"
#include "base/ecs/components/space_transform/WorldSpaceCache.h"

TestLevel::TestLevel()
{
    //TESTED
	// auto&& entity = EngiApp->getEntityRegistry().create();
	// auto&& model = EngiApp->assets().lock()->get<Model>("body_v2");
	
	// EngiApp->getEntityRegistry().emplace<ModelComponent>(entity, model);
	// EngiApp->getEntityRegistry().emplace<Transform>(entity);
	// EngiApp->getEntityRegistry().emplace<PlayerComponent>(entity);

	// EngiApp->getEntityRegistry().get<Transform>(entity).m_pos = glm::fixvec3(1.f, 1.f, 1.f);

	// for (size_t i = 0; i < 10; i++)
	// {
	// 	auto&& entity2 = EngiApp->getEntityRegistry().create();
	// 	auto&& model2 = EngiApp->assets().lock()->get<Model>("spider");
		
	// 	EngiApp->getEntityRegistry().emplace<ModelComponent>(entity2, model2);
	// 	EngiApp->getEntityRegistry().emplace<Transform>(entity2);
	// }
	

	auto&& entity2 = EngiApp->getEntityRegistry().create();
	auto&& model2 = EngiApp->assets().lock()->get<Model>("spider");
	
	EngiApp->getEntityRegistry().emplace<ModelComponent>(entity2, model2);
	EngiApp->getEntityRegistry().emplace<Transform>(entity2);
	EngiApp->getEntityRegistry().emplace<PlayerComponent>(entity2);
	// EngiApp->getEntityRegistry().emplace<WorldSpaceCache>(entity2);
	// EngiApp->getEntityRegistry().emplace<RenderTransform>(entity2);
	// EngiApp->getEntityRegistry().emplace<SpaceTransform>(entity2);

	// EngiApp->getEntityRegistry().emplace<GravityComponent>(entity2).set_force(1);
	// EngiApp->getEntityRegistry().emplace<RigidBodyComponent>(entity2);


	auto v = EngiApp->getEntityRegistry().view<Camera>();
	auto cam = v.front();
	EngiApp->getEntityRegistry().emplace<WorldSpaceCache>(cam);
	EngiApp->getEntityRegistry().emplace<FloatingOrigin>(cam);
	EngiApp->getEntityRegistry().emplace<RenderTransform>(cam);
}

TestLevel::~TestLevel()
{
}
