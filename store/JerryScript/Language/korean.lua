lang.set_translate('ko')

local f = lang.find
local t = lang.translate

t(f('Script settings'), '스크립트 설정')
t(f('Disable JS notifications'), 'JS 알림 비활성화')
t(f('Makes the script not notify when stuff happens. These can be pretty useful so I don\'t recommend turning them off.'), '스크립트가 문제가 발생했을 때 알리지 않도록 합니다. 이것들은 꽤 유용할 수 있으므로 끄지 않는 것이 좋습니다.')
t(f('Double tap interval'), '더블 탭 간격')
t(f('Lets you set the maximum time between double taps in ms.'), '더블 탭 사이의 최대 시간을 ms 단위로 설정할 수 있습니다.')
t(f('Create translation template'), '번역 템플릿 만들기')
t(f('Creates a template file for translation in store/JerryScript/Language.'), 'store/JerryScript/Language에서 번역을 위한 템플릿 파일을 생성합니다.')
t(f('Player info settings'), '플레이어 정보 설정')
t(f('X position'), 'X 위치')
t(f('Y position'), 'Y 위치')
t(f('The size of the text.'), '텍스트의 크기입니다.')
t(f('Text alignment'), '텍스트 정렬')
t(f('1 is center, 2 is left and 3 is right.'), '1은 중앙, 2는 왼쪽, 3은 오른쪽입니다.')
t(f('Text colour'), '텍스트 색상')
t(f('Sets the colour of the text overlay.'), '텍스트 오버레이의 색상을 설정합니다.')
t(f('Display options'), '디스플레이 옵션')
t(f('Disable name'), '이름 비활성화')
t(f('Disable weapon'), '무기 비활성화')
t(f('Disable ammo info'), '탄약 정보 비활성화')
t(f('Disable damage type'), '손상 유형 비활성화')
t(f('Displays the type of damage the players weapon does, like melee / fire / bullets / mk2 ammo.'), '근접 / 화재 / 총알 / mk2 탄약과 같이 플레이어 무기가 입히는 피해 유형을 표시합니다.')
t(f('Disable vehicle'), '차량 비활성화')
t(f('Disable score'), '점수 비활성화')
t(f('Only shows when you or they have kills.'), '당신이나 그들이 킬을 가지고 있을 때만 보여줍니다.')
t(f('Disable moving indicator'), '이동 표시기 비활성화')
t(f('Disable aiming indicator'), '조준 표시기 비활성화')
t(f('Disable reload indicator'), '재장전 표시기 비활성화')
t(f('Safe monitor settings'), '안전한 모니터 설정')
t(f('Settings for the on screen text'), '화면 텍스트에 대한 설정')
t(f('Explosion settings'), '폭발 설정')
t(f('Settings for the different options that explode players in this script.'), '이 스크립트에서 플레이어를 폭발시키는 다양한 옵션에 대한 설정입니다.')
t(f('Loop delay'), '루프 지연')
t(f('Lets you set a custom delay between looped explosions.'), '반복되는 폭발 사이에 사용자 지정 지연을 설정할 수 있습니다.')
t(f('Ms'), '양')
t(f('The delay is the added total of ms, sec and min values.'), '지연은 ms, sec 및 min 값의 합계입니다.')
t(f('Seconds'), '초')
t(f('Minutes'), '분')
t(f('FX explosions'), 'FX 폭발')
t(f('Lets you choose effects instead of explosion type.'), '폭발 유형 대신 효과를 선택할 수 있습니다.')
t(f('Explosion type'), '폭발 유형')
t(f('FX type'), 'FX 유형')
t(f('none'), '없음')
t(f('Choose a fx explosion type.'), 'fx 폭발 유형을 선택합니다.')
t(f('Can\'t be silenced.'), '침묵할 수 없습니다.')
t(f('Colour can be changed.'), '색상을 변경할 수 있습니다.')
t(f('FX colour'), 'FX 색상')
t(f('Only works on some pfx\'s.'), '일부 pfx에서만 작동합니다.')
t(f('Camera shake'), '카메라 흔들림')
t(f('How much explosions shake the camera.'), '얼마나 많은 폭발이 카메라를 흔든다.')
t(f('Invisible explosions'), '보이지 않는 폭발')
t(f('Silent explosions'), '조용한 폭발')
t(f('Disable explosion damage'), '폭발 피해 비활성화')
t(f('Blame settings'), '비난 설정')
t(f('Lets you blame yourself or other players for your explosions, go to the player list to chose a specific player to blame.'), '폭발에 대해 자신이나 다른 플레이어를 비난하고 플레이어 목록으로 이동하여 비난할 특정 플레이어를 선택할 수 있습니다.')
t(f('Owned explosions'), '소유 폭발')
t(f('Will overwrite "Disable explosion damage".'), '"폭발 피해 비활성화"를 덮어씁니다.')
t(f('Blame'), '탓하다')
t(f('Will overwrite "Disable explosion damage" and if you haven\'t chosen a player random players will be blamed for each explosion.'), '"폭발 피해 비활성화"를 덮어쓰고 플레이어를 선택하지 않은 경우 무작위 플레이어가 각 폭발에 대해 비난을 받습니다.')
t(f('Blame player list'), '비난 플레이어 목록')
t(f('Custom player list for selecting blames.'), '비난 선택을 위한 사용자 지정 플레이어 목록.')
t(f('Random blames'), '무작위 비난')
t(f('Switches blamed explosions back to random if you already chose a player to blame.'), '비난할 플레이어를 이미 선택한 경우 비난 폭발을 다시 무작위로 전환합니다.')
t(f('Horn boost multiplier'), '혼 부스트 승수')
t(f('Set the force applied to the car when you or another player uses horn boost.'), '본인 또는 다른 플레이어가 경적 부스트를 사용할 때 자동차에 적용되는 힘을 설정합니다.')
t(f('Ironman mode'), '아이언맨 모드')
t(f('Grants you the abilities of ironman :)'), '아이언맨의 능력을 부여합니다 :)')
t(f('Fire wings'), '불 날개')
t(f('Puts wings made of fire on your back.'), '등에 불로 만든 날개를 단다.')
t(f('Fire wings scale'), '불 날개 가늠자')
t(f('Fire wings colour'), '불 날개 색상')
t(f('Face features'), '얼굴 특징')
t(f('Customize face features'), '얼굴 기능 사용자 지정')
t(f('Customizations reset after restarting the game.'), '게임을 다시 시작하면 사용자 정의가 재설정됩니다.')
t(f('Nose Width'), '코 폭')
t(f('Nose Peak Hight'), '코 피크 높이')
t(f('Nose Peak Length'), '코 피크 길이')
t(f('Nose Bone Hight'), '코뼈 높이')
t(f('Nose Peak Lowering'), '코 피크 낮추기')
t(f('Nose Bone Twist'), '코뼈 트위스트')
t(f('Eyebrow Hight'), '눈썹 높이')
t(f('Eyebrow Forward'), '눈썹 앞으로')
t(f('Cheeks Bone Hight'), '뺨 뼈 높이')
t(f('Cheeks Bone Width'), '뺨 뼈 너비')
t(f('Cheeks Width'), '볼 너비')
t(f('Eyes Opening'), '눈 뜨기')
t(f('Lips Thickness'), '입술 두께')
t(f('Jaw Bone Width'), '턱뼈 너비')
t(f('Jaw Bone Back Length'), '턱뼈 뒤 길이')
t(f('Chin Bone Lowering'), '턱뼈 낮추기')
t(f('Chin Bone Length'), '턱뼈 길이')
t(f('Chin Bone Width'), '턱뼈 너비')
t(f('Chin Hole'), '턱 구멍')
t(f('Neck Width'), '목 너비')
t(f('Create face feature profile'), '얼굴 특징 프로필 만들기')
t(f('Saves your customized face in a file so you can load it.'), '로드할 수 있도록 사용자 정의된 얼굴을 파일에 저장합니다.')
t(f('Reload profiles'), '프로필 다시 로드')
t(f('Refreshes your profiles without having to restart the script.'), '스크립트를 다시 시작할 필요 없이 프로필을 새로 고칩니다.')
t(f('Customize face overlays'), '얼굴 오버레이 사용자 지정')
t(f('Blemishes'), '흠')
t(f('Eyebrows'), '눈썹')
t(f('Ageing'), '노화')
t(f('Makeup'), '구성하다')
t(f('Blush'), '붉히다')
t(f('Complexion'), '안색')
t(f('Sun Damage'), '태양 피해')
t(f('Lipstick'), '립스틱')
t(f('Moles/Freckles'), '기미/주근깨')
t(f('Chest Hair'), '가슴 털')
t(f('Body Blemishes'), '몸의 흠집')
t(f('Add Body Blemishes'), '신체 결점 추가')
t(f('Ragdoll options'), '랙돌 옵션')
t(f('Different options for making yourself ragdoll.'), '자신을 ragdoll 만들기위한 다양한 옵션.')
t(f('Better clumsiness'), '더 나은 서투름')
t(f('Like stands clumsiness, but you can get up after you fall.'), '서 있는 것처럼 서투르지만 넘어져도 일어설 수 있다.')
t(f('Stumble'), '채이기')
t(f('Makes you stumble with a good chance of falling over.'), '넘어질 확률이 높아 걸려 넘어집니다.')
t(f('Fall over'), '갑자기 중단되다')
t(f('Makes you stumble, fall over and prevents you from getting back up.'), '당신을 걸려 넘어지게 하고 다시 일어나지 못하게 합니다.')
t(f('Ragdoll'), '랙돌')
t(f('Just makes you ragdoll.'), '그냥 당신을 래그돌로 만듭니다.')
t(f('Ghost'), '귀신')
t(f('Makes your player different levels off see through.'), '플레이어가 다른 레벨을 통해 볼 수 있습니다.')
t(f('Full regen'), '완전 재생')
t(f('Makes your hp regenerate until you\'re at full health.'), '체력이 완전히 회복될 때까지 HP를 재생합니다.')
t(f('Cold blooded'), '냉혈')
t(f('Removes your thermal signature.\nOther players still see it tho.'), '열 신호를 제거합니다.\n다른 플레이어는 여전히 그것을 봅니다.')
t(f('Quiet footsteps'), '조용한 발걸음')
t(f('Disables the sound of your footsteps.'), '발자국 소리를 비활성화합니다.')
t(f('Thermal guns'), '열총')
t(f('Makes it so when you aim any gun you can toggle thermal vision on "E".'), '총을 조준할 때 "E"에서 열 화상을 토글할 수 있습니다.')
t(f('Weapon settings'), '무기 설정')
t(f('Disable recoil'), '반동 비활성화')
t(f('Disables the camera shake when shooting guns.'), '총을 쏠 때 카메라 흔들림을 비활성화합니다.')
t(f('Infinite range'), '무한 범위')
t(f('Disable spread'), '확산 비활성화')
t(f('Remove spin-up time'), '스핀업 시간 제거')
t(f('Removes the spin-up from both the minigun and the widowmaker.'), '미니건과 위도우메이커 모두에서 스핀업을 제거합니다.')
t(f('Bullet force multiplier'), '총알 힘 승수')
t(f('Works best when shooting vehicles from the front.\nDisplayed value is in percent.'), '전방에서 차량을 촬영할 때 가장 잘 작동합니다.\n표시된 값은 퍼센트입니다.')
t(f('Aim fov'), '조준')
t(f('Enable aim fov'), '조준 FOV 활성화')
t(f('Lets you modify the fov you have while you\'re aiming.'), '조준하는 동안 시야를 수정할 수 있습니다.')
t(f('Zoom aim fov'), '줌 조준 포브')
t(f('Enable zoom fov'), '줌 포브 사용')
t(f('Lets you modify the fov you have while you\'re aiming and has zoomed in.'), '조준하고 확대한 상태에서 시야를 수정할 수 있습니다.')
t(f('Proxy stickys'), '프록시 스티커')
t(f('Makes your sticky bombs automatically detonate around players or npc\'s, works with the player whitelist.'), '플레이어 또는 NPC 주변에서 점착 폭탄이 자동으로 폭발하도록 하고 플레이어 화이트리스트와 함께 작동합니다.')
t(f('Detonate near players'), '플레이어 근처에서 폭발')
t(f('If your sticky bombs automatically detonate near players.'), '점착 폭탄이 플레이어 근처에서 자동으로 폭발하는 경우.')
t(f('Detonate near npc\'s'), 'npc 근처에서 폭발')
t(f('If your sticky bombs automatically detonate near npc\'s.'), '점착 폭탄이 npc 근처에서 자동으로 폭발하는 경우.')
t(f('Detonation radius'), '폭발 반경')
t(f('How close the sticky bombs have to be to the target to detonate.'), '점착 폭탄이 폭발하기 위해 표적에 얼마나 가까이 있어야 하는지를 나타냅니다.')
t(f('Remove all sticky bombs'), '모든 점착 폭탄 제거')
t(f('Removes every single sticky bomb that exists (not only yours).'), '(당신뿐만 아니라) 존재하는 모든 단일 점착 폭탄을 제거합니다.')
t(f('Friendly fire'), '친절한 불')
t(f('Makes you able to shoot peds the game count as your friends.'), 'ped를 쏠 수 있도록 하면 게임이 친구로 간주됩니다.')
t(f('Reload when rolling'), '롤링할 때 재장전')
t(f('Reloads your weapon when doing a roll.'), '롤을 할 때 무기를 재장전합니다.')
t(f('Nuke options'), '핵 옵션')
t(f('Nuke gun'), '핵무기')
t(f('Makes the rpg fire nukes'), 'RPG를 핵무기로 만듭니다.')
t(f('Nuke waypoint'), '핵 웨이포인트')
t(f('Drops a nuke on your selected Waypoint.'), '선택한 웨이포인트에 핵을 투하합니다.')
t(f('Nuke height'), '핵 높이')
t(f('The height of the nukes you drop.'), '떨어뜨리는 핵무기의 높이입니다.')
t(f('Throwables launcher'), '투척 가능 발사기')
t(f('Makes the grenade launcher able to shoot throwables, gives you the throwable if you don\'t have it so you can shoot it.'), '유탄 발사기가 투척 무기를 쏠 수 있게 하고, 투척 무기가 없으면 쏠 수 있도록 던집니다.')
t(f('Current throwable'), '현재 던질 수 있는')
t(f('Choose what throwable the grenade launcher has.'), '유탄 발사기가 무엇을 던질 수 있는지 선택하십시오.')
t(f('Explosive animal gun'), '폭발성 동물 총')
t(f('Inspired by impulses explosive whale gun, but can fire other animals too.'), '충동 폭발 고래 총에서 영감을 얻었지만 다른 것을 발사할 수 있습니다동물도.')
t(f('Current animal'), '현재 동물')
t(f('Choose wat animal the explosive animal gun has.'), '폭발성 동물 총이 가지고 있는 와트 동물을 선택하십시오.')
t(f('Minecraft gun'), '마인크래프트 총')
t(f('Spawns blocks where you shoot.'), '당신이 쏘는 곳에서 블록을 생성합니다.')
t(f('Delete last block'), '마지막 블록 삭제')
t(f('Delete all blocks'), '모든 블록 삭제')
t(f('Speed and handling'), '속도와 핸들링')
t(f('Low traction'), '낮은 견인력')
t(f('Makes your vehicle have low traction, I recommend setting this to a hotkey.'), '차량의 견인력을 낮추기 때문에 핫키로 설정하는 것이 좋습니다.')
t(f('Launch control'), '런치 컨트롤')
t(f('Limits how much force your car applies when accelerating so it doesn\'t burnout, very noticeable in a Emerus.'), '가속할 때 자동차가 가하는 힘을 제한하여 타지 않도록 하며 Emerus에서는 매우 눈에 띕니다.')
t(f('Set torque'), '토크 설정')
t(f('Modifies the speed of your vehicle.'), '차량의 속도를 수정합니다.')
t(f('Quick brake'), '빠른 브레이크')
t(f('Slows down your speed more when pressing "S".'), '"S"를 누르면 속도가 더 느려집니다.')
t(f('Quick brake force'), '빠른 제동력')
t(f('1.00 is ordinary brakes.'), '1.00은 일반 브레이크입니다.')
t(f('Boosts'), '부스트')
t(f('Horn boost'), '경적 부스트')
t(f('Makes your car speed up when you honking your horn or activating your siren.'), '경적을 울리거나 사이렌을 작동시키면 자동차 속도가 빨라집니다.')
t(f('Vehicle jump'), '차량 점프')
t(f('Lets you jump with your car if you double tap "W".'), '"W"를 두 번 탭하면 자동차와 함께 점프할 수 있습니다.')
t(f('Nitro'), '니트로')
t(f('Enable nitro'), '니트로 활성화')
t(f('Enable nitro boost on any vehicle, use it by pressing "X".'), '모든 차량에서 니트로 부스트를 활성화하고 "X"를 눌러 사용하십시오.')
t(f('Duration'), '지속')
t(f('s'), '에스')
t(f('Lets you set a customize how long the nitro lasts.'), '니트로 지속 시간을 사용자 정의할 수 있습니다.')
t(f('Recharge time'), '재충전 시간')
t(f('Lets you set a custom delay of how long it takes for nitro to recharge.'), '니트로가 재충전되는 데 걸리는 시간에 대한 사용자 지정 지연을 설정할 수 있습니다.')
t(f('Shunt boost'), '션트 부스트')
t(f('Lets you shunt boost in any vehicle by double tapping "A" or "D".'), '"A" 또는 "D"를 두 번 탭하여 모든 차량에서 션트 부스트를 사용할 수 있습니다.')
t(f('Disable recharge'), '재충전 비활성화')
t(f('Removes the force build-up of the shunt boost.'), '션트 부스트의 힘 축적을 제거합니다.')
t(f('Force'), '힘')
t(f('How much force is applied to your car.'), '얼마나 많은 힘이 당신의 차에 가해집니다.')
t(f('Vehicle doors'), '차량 도어')
t(f('Indestructible doors'), '파괴할 수 없는 문')
t(f('Makes it so your vehicle doors can\'t break off.'), '차량 문이 부서지지 않도록 합니다.')
t(f('Shut doors when driving'), '운전할 때 문을 닫으십시오')
t(f('Closes all the vehicle doors when you start driving.'), '운전을 시작하면 모든 차량 도어를 닫습니다.')
t(f('Open all doors'), '모든 문 열기')
t(f('Made this to test door stuff.'), '도어트림 테스트용으로 만들었습니다.')
t(f('Close all doors'), '모든 문 닫기')
t(f('Plane options'), '비행기 옵션')
t(f('Toggle plane afterburner'), '비행기 애프터버너 전환')
t(f('Makes you able to toggle afterburner on planes by pressing "left shift".'), '"왼쪽 시프트"를 눌러 비행기에서 애프터버너를 전환할 수 있습니다.')
t(f('Lock vtol'), '잠금 vtol')
t(f('Locks the angle of planes vtol propellers.'), '평면 vtol 프로펠러의 각도를 잠급니다.')
t(f('Ghost vehicle'), '유령 차량')
t(f('Makes your vehicle different levels off see through.'), '당신의 차량을 다른 레벨로 보이게 합니다.')
t(f('Disable exhaust pops'), '배기 팝 비활성화')
t(f('Disables those annoying exhaust pops that your car makes if it has a non-stock exhaust option.'), '재고가 없는 배기 옵션이 있는 경우 자동차에서 발생하는 성가신 배기 팝을 비활성화합니다.')
t(f('Stance'), '위치')
t(f('Activates stance on vehicles that support it.'), '지지하는 차량에 자세를 활성화합니다.')
t(f('Npc horn'), 'NPC 뿔')
t(f('Makes you horn like a npc. Also makes your car doors silent.'), '당신을 npc처럼 뿔나게 만듭니다. 또한 자동차 문을 조용하게 만듭니다.')
t(f('To the moon'), '달로')
t(f('Forces you info the sky if you\'re in a vehicle.'), '당신이 차량에 있다면 하늘에 정보를 강요합니다.')
t(f('Anchor'), '닻')
t(f('Forces you info the ground if you\'re in a air born vehicle.'), '당신이 공중에서 태어난 차량에 있다면 지상에 정보를 강요합니다.')
t(f('Fake money'), '가짜 돈')
t(f('Adds fake money, it is only a visual thing and you can\'t spend it.'), '가짜 돈을 추가하면 시각적인 것일 뿐 사용할 수 없습니다.')
t(f('Add fake money'), '가짜 돈 추가')
t(f('Adds money once.'), '돈을 한 번 추가합니다.')
t(f('Loop fake money'), '루프 가짜 돈')
t(f('Adds loops money with your chosen delay.'), '선택한 지연으로 루프 돈을 추가합니다.')
t(f('Show transaction pending'), '보류 중인 거래 표시')
t(f('Adds a loading transaction pending message when adding fake money.'), '가짜 돈을 추가할 때 로딩 트랜잭션 보류 메시지를 추가합니다.')
t(f('Fake money loop delay'), '가짜 돈 루프 지연')
t(f('Lets you set a custom delay to the fake money loop.'), '가짜 돈 루프에 대한 사용자 지정 지연을 설정할 수 있습니다.')
t(f('Bank fake money'), '은행 가짜 돈')
t(f('How much fake money that gets added into your bank.'), '은행에 추가되는 가짜 돈의 양.')
t(f('Cash fake money'), '현금 가짜 돈')
t(f('How much fake money that gets added in cash.'), '얼마나 많은 가짜 돈이 현금으로 추가됩니다.')
t(f('Safe monitor'), '안전한 모니터')
t(f('Safe monitor allows you to monitor your safes. It does NOT affect the money being generated.'), '안전 모니터를 사용하면 금고를 모니터링할 수 있습니다. 생성되는 돈에는 영향을 미치지 않습니다.')
t(f('Toggle all selected'), '선택 항목 모두 전환')
t(f('Toggles every option.'), '모든 옵션을 토글합니다.')
t(f('Nightclub Safe'), '나이트클럽 금고')
t(f('Monitors nightclub safe cash, this does NOT affect income.'), '나이트클럽 안전 현금을 모니터링하며 이는 수입에 영향을 미치지 않습니다.')
t(f('Nightclub Popularity'), '나이트클럽 인기도')
t(f('Nightclub Daily Earnings'), '나이트클럽 일일 수입')
t(f('Nightclub daily earnings.\nMaximum daily earnings is 10k.'), '나이트클럽 일일 수입.\n최대 일일 수입은 10,000입니다.')
t(f('Arcade safe'), '아케이드 금고')
t(f('Monitors arcade safe cash, this does NOT affect income.\nMaximum daily earnings is 5k if you have all the arcade games.'), '아케이드 금고 현금을 모니터링하며 이는 수입에 영향을 미치지 않습니다.\n모든 아케이드 게임이 있는 경우 최대 일일 수입은 5k입니다.')
t(f('Agency safe'), '기관 안전')
t(f('Monitors agency safe cash, this does NOT affect income.\nMaximum daily earnings is 20k.'), '대행사 안전 현금을 모니터링하며 이는 수입에 영향을 미치지 않습니다.\n최대 일일 수입은 20,000입니다.')
t(f('Security contracts'), '보안 계약')
t(f('Displays the number of agency security missions you have completed.'), '완료한 기관 보안 임무의 수를 표시합니다.')
t(f('Agency daily Earnings'), '대행사 일일 수입')
t(f('Agency daily earnings.\nMaximum daily earnings is 20k if you have completed 200 contracts.'), '대행사 일일 수입.\n200 계약을 완료한 경우 최대 일일 수입은 20,000입니다.')
t(f('Increase safe earnings'), '안전한 수입 증가')
t(f('Might be risky.'), '위험할 수 있습니다.')
t(f('Auto nightclub popularity'), '자동 나이트 클럽 인기도')
t(f('Automatically sets the nightclubs popularity to 100 if it results in less than max daily income.'), '최대 일일 수입보다 적은 경우 나이트클럽 인기도를 100으로 자동 설정합니다.')
t(f('Property tp\'s'), '속성 tp\'s')
t(f('Lets you teleport to the properties you own.'), '소유한 속성으로 순간이동할 수 있습니다.')
t(f('Cooldowns'), '재사용 대기시간')
t(f('Agency'), '대행사')
t(f('Terrorbyte'), '테러바이트')
t(f('CEO/VIP'), 'CEO/VIP')
t(f('Payphone hits'), '공중전화 조회수')
t(f('Use this before picking up the payphone.'), '공중전화를 받기 전에 이것을 사용하십시오.')
t(f('Use this after completing the job.'), '작업 완료 후 사용하십시오.')
t(f('Between jobs'), '작업 간')
t(f('Robbery in progress'), '강도 진행 중')
t(f('Use this before starting the job.'), '작업을 시작하기 전에 이것을 사용하십시오.')
t(f('Data sweep'), '데이터 스윕')
t(f('Targeted data'), '타겟 데이터')
t(f('Diamond shopping'), '다이아몬드 쇼핑')
t(f('Casino work'), '카지노 작업')
t(f('CEO/VIP work'), 'CEO/VIP 업무')
t(f('Stand has this as a toggle, but that option doesn\'t work if you activate it when the cooldown has started, this does.'), '스탠드에는 이것을 토글로 사용할 수 있지만 쿨다운이 시작될 때 활성화하면 해당 옵션이 작동하지 않습니다.')
t(f('Headhunter'), '헤드 헌터')
t(f('Use this before starting the mission.'), '임무를 시작하기 전에 이것을 사용하십시오.')
t(f('Sightseer'), '관광객')
t(f('Asset recovery'), '자산 회수')
t(f('No theres no recoveries here.'), '아니 여기에는 복구가 없습니다.')
t(f('Lucky wheel cooldown'), '행운의 바퀴 쿨다운')
t(f('Tells you if the lucky wheel is available or how much time is left until it is.'), '행운의 바퀴를 사용할 수 있는지 또는 사용할 수 있을 때까지 남은 시간을 알려줍니다.')
t(f('Casino loss/profit'), '카지노 손실/이익')
t(f('Tells you how much you made or lost in the casino.'), '카지노에서 벌거나 잃은 금액을 알려줍니다.')
t(f('Time trials'), '타임 트라이얼')
t(f('Time trial'), '타임 트라이얼')
t(f('Best time trial time'), '최고의 타임 트라이얼 시간')
t(f('Teleport to time trial'), '타임 트라이얼로 텔레포트')
t(f('Rc time trial'), 'Rc 타임 트라이얼')
t(f('Best rc time trial time'), '최고의 rc 타임 트라이얼 타임')
t(f('Teleport to rc time trial'), 'rc 타임 트라이얼로 텔레포트')
t(f('Block areas'), '블록 영역')
t(f('Block areas in online with invisible walls, but if you over use it it will crash you lol.'), '온라인에서 보이지 않는 벽으로 영역을 차단하지만 과도하게 사용하면 충돌합니다.')
t(f('Custom block'), '사용자 정의 블록')
t(f('Makes you able to block an area in front of you by pressing "B".'), '"B"를 눌러 전방 영역을 차단할 수 있습니다.')
t(f('Block LSC'), '블록 LSC')
t(f('Block lsc from being accessed.'), 'lsc에 대한 액세스를 차단합니다.')
t(f('Block casino'), '블록 카지노')
t(f('Block casino from being accessed.'), '카지노 액세스를 차단합니다.')
t(f('Block maze bank'), '블록 미로 은행')
t(f('Block maze bank from being accessed.'), '미로 은행이 액세스되지 않도록 차단하십시오.')
t(f('orbital room'), '궤도실')
t(f('burton'), '버튼')
t(f('LSIA'), 'LSIA')
t(f('la meza'), '라 메자')
t(f('blaine county'), '블레인 카운티')
t(f('paleto bay'), '팔레토 베이')
t(f('benny\'s'), '베니의')
t(f('casino entrance'), '카지노 입구')
t(f('casino garage'), '카지노 차고')
t(f('lucky wheel'), '행운의 바퀴')
t(f('maze bank entrance'), '미로 은행 입구')
t(f('maze bank garage'), '미로 은행 차고')
t(f('hawick clubhouse'), '호윅 클럽하우스')
t(f('arena war garages'), '경기장 전쟁 차고')
t(f('Whitelist'), '화이트리스트')
t(f('Applies to most options in this section.'), '이 섹션의 대부분의 옵션에 적용됩니다.')
t(f('Exclude self'), '본인 제외')
t(f('Will make you not explode yourself. Pretty cool option if you ask me ;P'), '스스로 폭발하지 않도록 할 것입니다. 당신이 나에게 묻는다면 꽤 멋진 옵션 ;P')
t(f('Exclude friends'), '친구 제외')
t(f('Will make you not explode your friends... if you have any. (;-;)'), '친구가 있다면 폭발하지 않도록 할 것입니다. (;-;)')
t(f('Exclude strangers'), '낯선 사람 제외')
t(f('If you only want to explode your friends I guess.'), '친구를 폭발시키고 싶다면 생각합니다.')
t(f('Whitelist player'), '화이트리스트 플레이어')
t(f('Lets you whitelist a single player by name.'), '다음을 통해 단일 플레이어를 화이트리스트에 추가할 수 있습니다이름.')
t(f('Whitelist player list'), '화이트리스트 플레이어 목록')
t(f('Custom player list for selecting  players you wanna whitelist.'), '화이트리스트에 추가하려는 플레이어를 선택하기 위한 사용자 지정 플레이어 목록.')
t(f('Anti chat spam'), '안티 채팅 스팸')
t(f('Kicks people if they spam chat.'), '스팸 채팅을 하면 사람들을 추방합니다.')
t(f('Ignore team chat'), '팀 채팅 무시')
t(f('Identical messages'), '동일한 메시지')
t(f('How many identical chat messages a player can send before getting kicked.'), '플레이어가 쫓겨나기 전에 보낼 수 있는 동일한 채팅 메시지의 수.')
t(f('Explode all'), '모두 폭발')
t(f('Makes everyone explode.'), '모두를 폭발시킵니다.')
t(f('Explode all loop'), '모든 루프 분해')
t(f('Constantly explodes everyone.'), '끊임없이 모두를 폭발시킵니다.')
t(f('Orbital cannon detection'), '궤도 대포 탐지')
t(f('Tells you when anyone starts using the orbital cannon'), '누군가 궤도 대포를 사용하기 시작하면 알려줍니다.')
t(f('Coloured otr reveal'), '컬러 otr 공개')
t(f('Marks otr players with coloured blips.'), '색상 표시로 otr 플레이어를 표시합니다.')
t(f('otr reveal colour'), 'otr 공개 색상')
t(f('Otr rgb reveal'), 'OTR RGB 공개')
t(f('Do stuff to all players vehicles.'), '모든 플레이어 차량에 작업을 수행하십시오.')
t(f('Lock burnout'), '번아웃 잠금')
t(f('Locks all player cars in burnout.'), '모든 플레이어 자동차를 번아웃 상태로 잠급니다.')
t(f('Modifies the speed of all player vehicles.'), '모든 플레이어 차량의 속도를 수정합니다.')
t(f('Force surface all subs'), '강제 표면 모든 서브')
t(f('Forces all Kosatkas to the surface.\nNot compatible with the whitelist.'), '모든 Kosatka를 표면으로 강제 표시합니다.\n화이트리스트와 호환되지 않습니다.')
t(f('No fly zone'), '비행 금지 구역')
t(f('Forces all players in air born vehicles into the ground.'), '공중에서 태어난 차량의 모든 플레이어를 지면으로 강제로 내보냅니다.')
t(f('Shoot gods'), '슛 신')
t(f('Disables godmode for other players when aiming at them. Mostly works on trash menus.'), '다른 플레이어를 조준할 때 Godmode를 비활성화합니다. 주로 휴지통 메뉴에서 작동합니다.')
t(f('Aim karma'), '목표 카르마')
t(f('Do stuff to players that aim at you.'), '당신을 노리는 플레이어에게 일을하십시오.')
t(f('Shoot'), '사격')
t(f('Shoots players that aim at you.'), '당신을 목표로하는 플레이어를 쏴.')
t(f('Explodes the player with your custom explosion settings.'), '사용자 정의 폭발 설정으로 플레이어를 폭발시킵니다.')
t(f('Disable godmode'), '신 모드 비활성화')
t(f('If a god mode player aims at you this disables their god mode by pushing their camera forwards.'), '신 모드 플레이어가 당신을 조준하면 카메라를 앞으로 밀어 신 모드를 비활성화합니다.')
t(f('Stands player aim punishments'), '스탠드 플레이어 조준 처벌')
t(f('Link to stands player aim punishments.'), '스탠드 플레이어 조준 처벌에 대한 링크.')
t(f('irl time'), '시간')
t(f('Makes the in game time match your irl time. Disables stands "Smooth Transition".'), '게임 시간을 irl 시간과 일치시킵니다. "부드러운 전환"을 비활성화합니다.')
t(f('Disable numpad'), '숫자 키패드 비활성화')
t(f('Disables numpad so you don\'t rotate your plane/submarine while navigating stand'), '스탠드를 탐색하는 동안 비행기/잠수함을 회전하지 않도록 숫자 키패드를 비활성화합니다.')
t(f('Map zoom level'), '지도 확대/축소 수준')
t(f('Enable footsteps'), '발자국 활성화')
t(f('Enables foot prints on all surfaces.'), '모든 표면에 발자국을 활성화합니다.')
t(f('Enable vehicle trails'), '차량 트레일 활성화')
t(f('Enables vehicle trails on all surfaces.'), '모든 표면에서 차량 트레일을 활성화합니다.')
t(f('Disable all map notifications'), '모든 지도 알림 비활성화')
t(f('Removes that constant spam.'), '지속적인 스팸을 제거합니다.')
t(f('Derail trains'), '탈선 열차')
t(f('Derails and stops all trains.'), '모든 열차를 탈선 및 정지시킵니다.')
t(f('Delete trains'), '열차 삭제')
t(f('Just becurse every script has train options, I gotta have an anti train option.'), '모든 스크립트에 기차 옵션이 있다는 점을 유념하세요. 기차 옵션이 있어야 합니다.')
t(f('Mark nearby trains'), '주변 열차 표시')
t(f('Marks nearby trains with purple blips.'), '보라색 표시로 근처 기차를 표시합니다.')
t(f('Peds'), '소아과')
t(f('Ragdoll peds'), '봉제 인형')
t(f('Makes all nearby peds fall over lol.'), '근처에 있는 모든 ped를 넘어지게 합니다.')
t(f('Death\'s touch'), '죽음의 손길')
t(f('Kills peds that touches you.'), '당신을 만지는 ped를 죽입니다.')
t(f('Cold peds'), '감기약')
t(f('Removes the thermal signature from all peds.'), '모든 ped에서 열 신호를 제거합니다.')
t(f('Mute peds'), '음소거')
t(f('Because I don\'t want to hear that dude talk about his gay dog any more.'), '그 친구가 자신의 게이 개에 대해 더 이상 이야기하는 것을 듣고 싶지 않기 때문입니다.')
t(f('Npc horn boost'), 'NPC 혼 부스트')
t(f('Boosts npcs that horn.'), '경적을 울리는 npc를 부스트합니다.')
t(f('Npc siren boost'), 'NPC 사이렌 부스트')
t(f('Boosts npcs cars with an active siren.'), '활성 사이렌으로 npcs 자동차를 부스트합니다.')
t(f('Auto kill enemies'), '적 자동 죽이기')
t(f('Just instantly kills hostile peds.'), '적대적인 ped를 즉시 죽입니다.')
t(f('Kill jacked peds'), '킬 잭 peds')
t(f('Automatically kills peds when stealing their car.'), '차를 훔치면 자동으로 ped를 죽입니다.')
t(f('Riot mode'), '폭동 모드')
t(f('Makes peds hostile.'), 'peds를 적대적으로 만듭니다.')
t(f('Join the discord server'), '디스코드 서버 가입')
t(f('Join the JerryScript discord server to suggest features, report bugs and test upcoming features.'), '기능을 제안하고 버그를 보고하고 향후 기능을 테스트하려면 JerryScript 디스코드 서버에 가입하세요.')
t(f('Coded by'), '코드 작성자')
t(f('Some contributions made by'), '일부 기여')
t(f('Skids from:'), '스키드 출처:')
t(f('by'), '~에 의해')
t(f('Thanks to'), '덕분에')
t(f('for reviewing my code'), '내 코드를 검토하기 위해')
t(f('Big thanks to all the cool people who helped me in #programming in the stand discord'), '스탠드 디스코드에서 #프로그래밍에 도움을 주신 모든 멋진 분들에게 큰 감사를 드립니다.')
t(f('For making stand and providing such a great api and documentation'), '스탠드를 만들고 훌륭한 API와 문서를 제공하기 위해')
t(f('Play credits'), '플레이 크레딧')
t(f('Blames your explosions on them.'), '당신의 폭발을 그들에게 돌립니다.')
t(f('from options that affect all players.'), '모든 플레이어에게 영향을 미치는 옵션에서.')
t(f('JerryScript'), '제리스크립트')
t(f('JS player options'), 'JS 플레이어 옵션')
t(f('Player info'), '선수 정보')
t(f('Display information about this player.'), '이 플레이어에 대한 정보를 표시합니다.')
t(f('Explode player'), '플레이어를 폭발')
t(f('Explodes this player with your selected options.'), '선택한 옵션으로 이 플레이어를 분해합니다.')
t(f('Explode loop player'), '폭발 루프 플레이어')
t(f('Loops explosions on them with your selected options.'), '선택한 옵션으로 폭발을 반복합니다.')
t(f('Blame explosions'), '비난 폭발')
t(f('Makes your explosions blamed on them.'), '당신의 폭발이 그들에게 책임이 있습니다.')
t(f('Damage'), '손상')
t(f('Primed grenade'), '프라이밍 수류탄')
t(f('Spawns a grenade on top of them.'), '그 위에 수류탄을 생성합니다.')
t(f('Sticky'), '어려운')
t(f('Spawns a sticky bomb on them that might stick to their vehicle and you can detonate by pressing "G".'), '차량에 달라붙을 수 있는 점착 폭탄을 생성하고 "G"를 눌러 폭파할 수 있습니다.')
t(f('Undetected money drop 2022'), '감지되지 않은 돈 하락 2022')
t(f('Drops money bags that wont give any money.'), '돈을 주지 않는 돈가방을 떨어뜨립니다.')
t(f('Entity YEET'), '엔티티 YEET')
t(f('Pushes all peds and vehicles near them.. into them ;)\nRequires you to be near them or spectating them.'), '근처에 있는 모든 ped와 차량을 밀어 넣습니다.. ;)\n그 근처에 있거나 관전해야 합니다.')
t(f('Entity Storm'), '엔티티 스톰')
t(f('Constantly pushes all peds and vehicles near them.. into them :p\nRequires you to be near them or spectating them.'), '주변의 모든 ped와 차량을 지속적으로 밀어 넣습니다.. :p\n가까이 있거나 관전해야 합니다.')
t(f('Range for YEET/Storm'), 'YEET/Storm 범위')
t(f('How close nearby entities have to be to get pushed the targeted player.'), '타겟 플레이어를 밀어내기 위해 가까운 엔티티가 얼마나 가까이 있어야 하는지입니다.')
t(f('Multiplier for YEET/Storm'), 'YEET/Storm의 승수')
t(f('Multiplier for how much force is applied to entities when they get pushed towards them.'), '엔티티를 향해 밀렸을 때 엔티티에 적용되는 힘의 승수입니다.')
t(f('Storm delay'), '폭풍 지연')
t(f('Lets you set the delay for how often entities are pushed in entity storm.'), '엔티티 폭풍에서 엔티티가 푸시되는 빈도에 대한 지연을 설정할 수 있습니다.')
t(f('Give shoot gods'), '슛 신을 줘')
t(f('Grants this player the ability to disable players god mode when shooting them.'), '이 플레이어를 쏠 때 플레이어의 신 모드를 비활성화할 수 있는 능력을 부여합니다.')
t(f('Give horn boost'), '경적 부스트 주기')
t(f('Gives them the ability to speed up their car by pressing honking their horn or activating the siren.'), '경적을 울리거나 사이렌을 작동시켜 자동차 속도를 높일 수 있습니다.')
t(f('Give aim karma'), '목표 카르마 부여')
t(f('Allows you to to stuff to players who target this player.'), '이 플레이어를 대상으로 하는 플레이어에게 물건을 줄 수 있습니다.')
t(f('Shoots players that aim at them.'), '그들을 겨냥한 플레이어를 쏜다.')
t(f('Explosions with your custom explosion settings.'), '사용자 정의 폭발 설정으로 폭발.')
t(f('If a god mode player aims at them this disables the aimers god mode by pushing their camera forwards.'), '신 모드 플레이어가 조준하면 카메라를 앞으로 밀어 조준 신 모드를 비활성화합니다.')
t(f('Locks their car in a burnout.'), '번아웃에 차를 잠급니다.')
t(f('Modifies the speed of their vehicle.'), '차량의 속도를 수정합니다.')
t(f('Surface submarine'), '수상잠수함')
t(f('Forces their submarine to the surface if they\'re driving it.'), '그들이 운전하는 경우 잠수함을 수면으로 밀어냅니다.')
t(f('Forces their vehicle into the sky.'), '차량을 하늘로 강제로 띄웁니다.')
t(f('Forces their vehicle info the ground if its in the air.'), '차량 정보가 공중에 있는 경우 지상에 강제로 정보를 제공합니다.')
t(f('Entity rain'), '엔티티 비')
t(f('Meow rain'), '야옹 비')
t(f('UWU'), '우우')
t(f('Sea rain'), '바다 비')
t(f('<º)))><'), '<º)))><')
t(f('Dog rain'), '개 비')
t(f('Wooof'), '우프')
t(f('Chicken rain'), '치킨 레인')
t(f('*clucking*'), '*딸꾹질*')
t(f('Monkey rain'), '원숭이 비')
t(f('Idk what sound a monkey does'), '원숭이가 무슨 소리를 하는지')
t(f('Pig rain'), '돼지 비')
t(f('(> (00) <)'), '(> (00) <)')
t(f('Rat rain'), '쥐 비')
t(f('Puts a Remote access trojan in your pc. (JK)'), '원격 액세스 트로이 목마를 PC에 넣습니다. (JK)')
t(f('Clear rain'), '맑은 비')
t(f('Deletes rained entities.'), '비가 내린 엔티티를 삭제합니다.')

t(f('Notifications on'), '알림')
t(f('Failed to create file.'), '파일을 생성하지 못했습니다.')
t(f('Explosions stopped because the player you\'re blaming left.'), '당신이 비난하는 플레이어가 왼쪽에 있기 때문에 폭발이 멈췄습니다.')
t(f('Profile not found.'), '프로필을 찾을 수 없습니다.')
t(f('Failed to find memory address.'), '메모리 주소를 찾지 못했습니다.')
t(f('No waypoint set.'), '웨이포인트가 설정되지 않았습니다.')
t(f('Shunt boost fully recharged'), '션트 부스트가 완전히 충전됨')
t(f('Closed your car doors.'), '차 문을 닫았습니다.')
t(f('Cooldown active'), '재사용 대기시간')
t(f('You can only use this while in a session.'), '세션 중에만 사용할 수 있습니다.')
t(f('You already reached 200 completions.'), '이미 200회 완료했습니다.')
t(f('Couldn\'t find property.'), '쿨속성을 찾을 수 없습니다.')
t(f('Lucky wheel is available.'), '행운의 바퀴를 사용할 수 있습니다.')
t(f('You haven\'t made or lost any chips.'), '당신은 칩을 만들거나 잃어 버리지 않았습니다.')
t(f('Couldn\'t find time trial.'), '타임 트라이얼을 찾을 수 없습니다.')
t(f('Couldn\'t find rc time trial.'), 'rc 타임 트라이얼을 찾을 수 없습니다.')
t(f('A block is already being run.'), '블록이 이미 실행 중입니다.')
t(f('Applied force'), '적용된 힘')
t(f('Marked train'), '표시된 열차')
t(f('Failed to get latest release.'), '최신 릴리스를 가져오지 못했습니다.')

t(f('Weapon'), '무기')
t(f('Clip'), '클립')
t(f('Damage type'), '손상 유형')
t(f('Vs'), '대')
t(f('Player is'), '플레이어는')
t(f('Player is aiming at you'), '플레이어가 당신을 노리고 있습니다')
t(f('Player is reloading'), '플레이어가 새로고침 중입니다.')
t(f('Can\'t be silenced.'), '침묵할 수 없습니다.')
t(f('Fx active'), 'FX 활성')
t(f('Will overwrite "Disable explosion damage" and if you haven\'t chosen a player random players will be blamed for each explosion.'), '"폭발 피해 비활성화"를 덮어쓰고 플레이어를 선택하지 않은 경우 무작위 플레이어가 각 폭발에 대해 비난을 받습니다.')
t(f('Beam'), '빔')
t(f('Barrage'), '연발 사격')
t(f('Nightclub Cash'), '나이트클럽 현금')
t(f('Arcade Cash'), '아케이드 현금')
t(f('Agency Cash'), '대리점 현금')
t(f('Agency Daily Earnings'), '대행사 일일 수입')
t(f('You\'ve made'), '당신이 만들었습니다')
t(f('chips.'), '작은 조각.')
t(f('You\'ve lost'), '당신은 졌다')
t(f('Best Time'), '최고의 시간')
t(f('is already blocked.'), '이미 차단되었습니다.')
t(f('Blocking'), '블로킹')
t(f('Successfully blocked'), '성공적으로 차단됨')
t(f('Whitelisted'), '화이트리스트')
t(f('Kicked'), '차다')
t(f('for chat spam.'), '채팅 스팸용.')
t(f('is using the orbital cannon'), '궤도포를 사용하고 있다')
t(f('Surfaced'), '표면화')
t(f('submarines.'), '잠수함.')
t(f('And thank you'), '그리고 감사합니다')
t(f('for using JerryScript'), 'JerryScript를 사용하기 위해')
t(f('Forcing'), '강제')
t(f('\'s submarine to the surface.'), '수면으로의 잠수함.')
t(f('min'), '분')
t(f('I can\'t guarantee that these options are 100% safe. I tested them on my main, but im stupid.'), '이러한 옵션이 100% 안전하다고 보장할 수 없습니다. 나는 그것들을 내 메인에서 테스트했지만 나는 바보입니다.')
