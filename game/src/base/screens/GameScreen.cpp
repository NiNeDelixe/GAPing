#include "GameScreen.h"

#include "base/screens/MenuScreen.h"

GameScreen::GameScreen(const std::shared_ptr<World>& world)
	: render(world), m_world(world), m_pause_ui_it(EngiApp->getUis().end())
{
	EngiApp->window()->events()->lockCursor(true);
    EngiApp->getSystemManager()->emplaceSystems<GameSystemFactory>();
}

GameScreen::~GameScreen()
{
	hidePauseMenu();
    EngiApp->window()->events()->lockCursor(false);
}

void GameScreen::update(const float& delta)
{
	if (ImGui::IsKeyPressed(ImGuiKey_Escape, false))
    {
        togglePause();
    }

	render.render();

	if (m_is_paused)
    {
		return;
    }
}

void GameScreen::draw(const float& delta)
{
}

void GameScreen::setPaused(bool paused)
{
    m_is_paused = paused;
    EngiApp->window()->events()->lockCursor(!m_is_paused);

    if (m_is_paused)
    {
        showPauseMenu();
		EngiApp->pausePolling();
        return;
    }

	EngiApp->resumePolling();
    hidePauseMenu();
}

void GameScreen::showPauseMenu()
{
    if (m_has_pause_ui)
    {
        return;
    }

    m_pause_ui_it = EngiApp->getUis().emplace(EngiApp->getUis().end(),
        std::make_shared<PauseMenuUi>(
            [this]() { setPaused(false); },
            [this]() { exitToMainMenu(); }));
    m_has_pause_ui = true;
}

void GameScreen::hidePauseMenu()
{
    if (!m_has_pause_ui)
    {
        return;
    }

    EngiApp->getUis().erase(m_pause_ui_it);
    m_pause_ui_it = EngiApp->getUis().end();
    m_has_pause_ui = false;
}

void GameScreen::togglePause()
{
    setPaused(!m_is_paused);
}

void GameScreen::exitToMainMenu()
{
    hidePauseMenu();
    m_is_paused = false;
    EngiApp->window()->events()->lockCursor(false);
    EngiApp->setScreen(std::make_shared<MenuScreen>());
}